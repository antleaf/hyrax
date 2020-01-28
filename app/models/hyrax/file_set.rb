# frozen_string_literal: true

module Hyrax
  ##
  # Valkyrie model for `FileSet` domain objects in the Hydra Works model.
  #
  # @see https://wiki.duraspace.org/display/samvera/Hydra%3A%3AWorks+Shared+Modeling
  class FileSet < Hyrax::Resource
    include Hyrax::Schema(:core_metadata)

    attribute :file_ids, Valkyrie::Types::Array.of(Valkyrie::Types::ID) # id for FileMetadata resources
    attribute :original_file_id, Valkyrie::Types::ID # id for FileMetadata resource
    attribute :thumbnail_id, Valkyrie::Types::ID # id for FileMetadata resource
    attribute :extracted_text_id, Valkyrie::Types::ID # id for FileMetadata resource

    ##
    # @return [Boolean] true
    def pcdm_object?
      true
    end

    ##
    # @return [Boolean] true
    def file_set?
      true
    end

    ##
    # Gives file metadata for the file filling the http://pcdm.org/OriginalFile use
    # @return [FileMetadata] the FileMetadata resource of the original file
    def original_file
      filter_files_by_type(Hyrax::FileMetadata::Use::ORIGINAL_FILE).first
    end

    ##
    # Gives file metadata for the file filling the http://pcdm.org/ExtractedText use
    # @return [FileMetadata] the FileMetadata resource of the extracted text
    def extracted_text
      filter_files_by_type(Hyrax::FileMetadata::Use::EXTRACTED_TEXT).first
    end

    ##
    # Gives file metadata for the file filling the http://pcdm.org/Thumbnail use
    # @return [FileMetadata] the FileMetadata resource of the thumbnail
    def thumbnail
      filter_files_by_type(Hyrax::FileMetadata::Use::THUMBNAIL).first
    end

    private

      ##
      # @api private
      #
      # Gives file metadata for files that have the requested RDF Type for use
      # @param [RDF::URI] uri for the desired Type
      # @return [Enumerable<FileMetadata>] the FileMetadata resources
      #
      # @example
      #   filter_files_by_type(::RDF::URI("http://pcdm.org/ExtractedText"))
      def filter_files_by_type(uri)
        Hyrax.query_service.custom_queries.find_many_file_metadata_by_use(resource: self, use: uri)
      end
  end
end
