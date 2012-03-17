class DownloadsController < ApplicationController
    include Hydra::RepositoryController
    include Hydra::AssetsControllerHelper
    helper :downloads
    
    # Note: Actual downloads are handled by the index method insead of the show method
    # in order to avoid ActionController being clever with the filenames/extensions/formats.
    # To download a datastream, pass the datastream id as ?document_id=#{dsid} in the url
    def index
      fedora_object = ActiveFedora::Base.load_instance(params[:asset_id])
      if params[:download_id]
        @datastream = fedora_object.datastreams[params[:download_id]]
        send_datastream @datastream
      else
        @datastreams = downloadables( fedora_object )
      end
    end
    
end
