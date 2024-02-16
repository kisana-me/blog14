module Images
  include ActiveStorage::Streaming
  include ActionController::DataStreaming
  include ActionController::Live
  def send_noblob_stream(noblob, blob, disposition: nil)
    send_stream(
        filename: noblob.filename.sanitized,
        disposition: noblob.forced_disposition_for_serving || disposition || DEFAULT_BLOB_STREAMING_DISPOSITION,
        type: noblob.content_type_for_serving) do |stream|
      blob.download do |chunk|
        stream.write chunk
      end
    end
  end
end