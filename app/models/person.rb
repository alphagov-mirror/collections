require "active_model"

class Person
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def base_path
    @content_item.content_item_data["base_path"]
  end

  def title
    @content_item.content_item_data["title"]
  end

  def current_roles_title
    current_roles.map { |role| role["title"] }.to_sentence
  end

  def previous_roles_items
    previous_roles.map do |role|
      {
        link: {
          text: role["title"],
          path: role["base_path"],
        },
        metadata: {
          appointment_duration: "#{role['start_year']} to #{role['end_year']}",
        },
      }
    end
  end

  def has_previous_roles?
    previous_roles.present?
  end

  def image_url
    details.dig("image", "url")
  end

  def image_alt_text
    details.dig("image", "alt_text")
  end

  def biography
    details["body"]
  end

  def announcement_items
    announcements.map do |annoucenment|
      {
        link: {
          text: annoucenment["title"],
          path: annoucenment["link"],
        },
        metadata: {
          public_timestamp: Date.parse(annoucenment["public_timestamp"]).strftime("%d %B %Y"),
          content_store_document_type: annoucenment["content_store_document_type"].humanize,
        },
      }
    end
  end

  def has_announcements?
    announcements.present?
  end

private

  def announcements
    @announcements ||= Services.cached_search(
      count: 10,
      order: "-public_timestamp",
      filter_people: slug,
      reject_content_purpose_supergroup: "other",
      fields: %w[title link content_store_document_type public_timestamp],
      )["results"]
  end

  def slug
    base_path.split("/").last
  end

  def current_roles
    links.fetch("ordered_current_appointments", [])
      .map { |appointment| appointment["links"]["role"].first }
  end

  def previous_roles
    links.fetch("ordered_previous_appointments", []).map do |previous_appointment|
      previous_appointment["links"]["role"].first.tap do |role|
        role["start_year"] = Time.parse(previous_appointment["details"]["started_on"]).strftime("%Y")
        role["end_year"] = Time.parse(previous_appointment["details"]["ended_on"]).strftime("%Y")
      end
    end
  end

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end
end
