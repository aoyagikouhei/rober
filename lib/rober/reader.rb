require 'nokogiri'

module Rober
  class Reader
    def self.read(path)
      if path.downcase.end_with?("edm")
        read_edm(path)
      elsif path.downcase.end_with?("dbm")
        read_dbm(path)
      else
        {}
      end
    end

    def self.read_edm(path)
      doc = Nokogiri::XML(file_read(path))
      entities = []
      doc.xpath('/ERD/ENTITY').each do |it|
        entity = Rober::Entity.new
        entity.logical_name = it[:"L-NAME"]
        entity.physical_name = it[:"P-NAME"]
        entity.comment = it[:"COMMENT"]
        it.xpath('ATTR').each do |attr|
          attribute = Rober::Attribute.new
          attribute.logical_name = attr[:"L-NAME"]
          attribute.physical_name = attr[:"P-NAME"]
          attribute.datatype = attr[:"DATATYPE"]
          attribute.length = attr[:"LENGTH"]
          attribute.scale = attr[:"SCALE"]
          attribute.null = attr[:"NULL"]
          attribute.def = attr[:"DEF"]
          attribute.pk = attr[:"PK"]
          entity.add(attribute)
        end
        entities << entity
      end
      {entities: entities}
    end

    def self.file_read(path)
      res = File.read(path)
      res.gsub(/\r\n/, "&#10;")
    end

    def self.read_dbm(path)
      doc = Nokogiri::XML(File.read(path))
      entities = []
      doc.xpath('/dbmodel/table').each do |it|
        
        entity = Rober::Entity.new
        entity.logical_name = it[:name]
        entity.physical_name = it[:name]
        list = it.xpath('./comment/text()')
        entity.comment = list.empty? ? '' : list.first.content
        list = it.xpath('constraint[@type="pk-constr"]')
        pk_ary = []
        unless list.empty?
          pk_ary = list.first.xpath('columns').map{|col| col[:names].split(/,/)}.flatten
        end
        it.xpath('column').each do |attr|
          type_tag = attr.xpath('./type').first
          attribute = Rober::Attribute.new
          attribute.logical_name = attr[:name]
          attribute.physical_name = attr[:name]
          attribute.datatype = type_tag[:name]
          attribute.length = type_tag[:length]
          attribute.scale = type_tag[:precision] || '0'
          attribute.null = attr[:"not-null"] == 'true' ? '1' : '0'
          attribute.def = attr[:"default-value"] || ''
          attribute.pk = pk_ary.include?(attribute.physical_name) ? '1' : '0'
          entity.add(attribute)
        end
        entities << entity
      end
      {entities: entities}
    end
  end
end
