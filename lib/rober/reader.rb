require 'nokogiri'

module Rober
  class Reader
    def self.read(path)
      doc = Nokogiri::XML(File.read(path))
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
  end
end
