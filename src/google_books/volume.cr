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
    id: String,
    etag: String,
    self_link: {type: String, key: "selfLink"},
    volume_info: {type: VolumeInfo, key: "volumeInfo"}
  )

  class VolumeInfo
    JSON.mapping(
      title: String,
      subtitle: {type: String, nilable: true},
      authors: {type: Array(String), nilable: true},
      publisher: String,
      published_date: {type: String, key: "publishedDate", nilable: true},
      description: {type: String, nilable: true},
      industry_identifiers: {type: Array(IndustryIdentifier), key: "industryIdentifiers", nilable: true},
      page_count: {type: Int32, key: "pageCount", nilable: true},
    )
  end

  class IndustryIdentifier
    JSON.mapping(
      type: String,
      identifier: String
    )
  end

  class ListResult
    JSON.mapping(
      kind: String,
      items: Array(Volume),
      total_items: {type: Int32, key: "totalItems"}
    )
  end
end
