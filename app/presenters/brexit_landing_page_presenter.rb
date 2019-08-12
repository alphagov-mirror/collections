require 'yaml'

class BrexitLandingPagePresenter
  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :child_taxons,
    :live_taxon?,
    :section_content,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def buckets
    buckets ||= YAML.load_file('config/brexit_campaign_buckets.yml')

    buckets.map do |bucket|
      if bucket["items"]
        bucket["items"].map do |link|
          link.symbolize_keys!
          link[:description] = link[:description].html_safe
        end
      end
    end

    buckets
  end

  def supergroup_sections
    sections ||= SupergroupSections.supergroup_sections(taxon.content_id, taxon.base_path)

    sections.map do |section|
      if section[:show_section]
        {
        text: I18n.t(section[:id], scope: :content_purpose_supergroup, default: section[:title]),
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data]
        }
      end
    end
  end

  def brexit?
    content_id == "d6c2de5d-ef90-45d1-82d4-5f2438369eea"
  end

  def days_left
    (Date.parse("31/10/2019 23:00:00") - Date.today).to_i
  end

  def show_countdown?
    days_left > -1
  end

  def days_text
    days_left == 1 ? "day" : "days"
  end
end
