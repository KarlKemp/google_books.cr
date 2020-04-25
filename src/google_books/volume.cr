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
      authors: {type: Array(String), default: [] of String},
      publisher: String,
      published_date: {type: String, key: "publishedDate", nilable: true},
      description: {type: String, nilable: true},
      industry_identifiers: {type: Array(IndustryIdentifier), key: "industryIdentifiers", nilable: true},
      page_count: {type: Int32, key: "pageCount", nilable: true},
      dimensions: {type: Dimensions, nilable: true},
      print_type: {type: String, key: "printType"},
      main_category: {type: String, key: "mainCategory", nilable: true},
      categories: {type: Array(String), default: [] of String},
      average_rating: {type: Float32, key: "averageRating", nilable: true},
      ratings_count: {type: Int32, key: "ratingsCount", nilable: true},
      content_version: {type: String, key: "contentVersion"},
      image_links: {type: ImageLinks, key: "imageLinks"}
    )
  end

  class IndustryIdentifier
    JSON.mapping(
      type: String,
      identifier: String
    )
  end

  class Dimensions
    JSON.mapping(
      height: String,
      width: String,
      thickness: String
    )
  end

  class ImageLinks
    JSON.mapping(
      small_thumbnail: {type: String, key: "smallThumbnail"},
      thumbnail: String,
      small: {type: String, nilable: true},
      medium: {type: String, nilable: true},
      large: {type: String, nilable: true},
      extra_large: {type: String, key: "extraLarge", nilable: true}
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
