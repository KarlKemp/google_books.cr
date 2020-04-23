class GoogleBooks::Volume
  def self.list(query) : ListResult
    response = HTTP::Client.get "https://www.googleapis.com/books/v1/volumes?q=#{query}"
    ListResult.from_json(response.body)
  end

  def self.get(id) : Volume?
    response = HTTP::Client.get "https://www.googleapis.com/books/v1/volumes/#{id}"
    return if response.status_code == 404
    return if response.status_code == 503

    Volume.from_json(response.body)
  end
  
  JSON.mapping(
    kind: String,
    id: String
  )

  class ListResult
    JSON.mapping(
      kind: String,
      items: Array(Volume),
      total_items: { type: Int32, key: "totalItems" }
    )
  end
end
