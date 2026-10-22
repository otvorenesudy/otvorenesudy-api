# frozen_string_literal: true

require 'rails_helper'
require 'spreadsheet'

# The export of prosecutors' property declarations from genpro.gov.sk (rake genpro_gov_sk:export_property_declarations):
# the prosecutors from the office's list, their declarations found by name, each read from its page, with what
# data/prosecutors-metadata.csv knows of the prosecutor. genpro.gov.sk is faked; the declaration page is a recorded one.
RSpec.describe GenproGovSk do
  let(:site) { 'https://www.genpro.gov.sk' }
  let(:search_url) { "#{site}/prokuratura-sr/majetkove-priznania-30a3.html" }
  let(:path) { Rails.root.join('tmp/genpro-export-spec.json') }

  before do
    stub_request(:get, "#{site}/prokuratura-sr/menny-zoznam-prokuratorov-slovenskej-republiky-3928.html").to_return(
      body: %(<a href="/extdoc/1/zoznam.xls">Menný zoznam prokurátorov Slovenskej republiky</a>)
    )
    stub_request(:get, "#{site}/extdoc/1/zoznam.xls").to_return(body: list('Vandžurová Nehilová Beáta, JUDr.'))
    stub_request(:get, search_url).to_return(body: search_form, headers: html)
    stub_request(:post, search_url).with(body: { meno: 'Beáta', priezvisko: 'Vandžurová Nehilová' })
                                   .to_return(body: results('?id=7361'), headers: { 'Content-Type' => 'text/html' })
    stub_request(:get, "#{search_url}?id=7361").to_return(
      body: file_fixture('genpro_gov_sk/property_declaration.html').binread,
      headers: { 'Content-Type' => 'text/html; charset=UTF-8' }
    )
  end

  after { FileUtils.rm_f(path) }

  def html
    { 'Content-Type' => 'text/html; charset=UTF-8' }
  end

  # The list of prosecutors genpro.gov.sk publishes as an Excel sheet: two lines of heading, then a name a row.
  def list(*names)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).replace(['Menný zoznam prokurátorov Slovenskej republiky'])
    sheet.row(1).replace(['P. č.', 'Meno'])
    names.each_with_index { |name, index| sheet.row(index + 2).replace([index + 1, name]) }

    StringIO.new.tap { book.write(it) }.string
  end

  def search_form
    <<~HTML
      <form name="uznesenia-form" method="post" action="/prokuratura-sr/majetkove-priznania-30a3.html">
        <input name="meno"><input name="priezvisko">
      </form>
    HTML
  end

  def results(*links)
    rows = links.map { %(<tr><td>1</td><td>2</td><td>3</td><td><a href="#{it}">2011</a></td></tr>) }

    %(<table class="table_01"><tbody>#{rows.join}</tbody></table>)
  end

  describe '.export_property_declarations' do
    it 'writes each prosecutor with their declarations and what the metadata says of them to a JSON file' do
      described_class.export_property_declarations(path:)

      prosecutor = JSON.parse(path.read).sole

      expect(prosecutor.except('property_declarations')).to eq(
        'name' => { 'value' => 'JUDr. Beáta Vandžurová Nehilová', 'first' => 'Beáta', 'middle' => 'Vandžurová',
                    'last' => 'Nehilová' },
        'organisation' => 'Okresná prokuratúra', 'municipality' => 'Prešov', 'position' => nil
      )
      expect(prosecutor['property_declarations'].pluck('year')).to eq([2011])
    end
  end

  describe GenproGovSk::PropertyDeclarationsCrawler do
    describe '.crawl_for' do
      it 'reads each declaration the search finds for the prosecutor' do
        stub_request(:post, search_url).to_return(body: results('?id=7361', '?id=7361'))

        declarations = described_class.crawl_for(first_name: 'Beáta', last_name: 'Vandžurová Nehilová')

        expect(declarations.pluck(:year)).to eq([2011, 2011])
      end

      it 'finds nothing for a prosecutor without declarations' do
        stub_request(:post, search_url).to_return(body: results)

        expect(described_class.crawl_for(first_name: 'Ján', last_name: 'Novák')).to eq([])
      end
    end
  end
end
