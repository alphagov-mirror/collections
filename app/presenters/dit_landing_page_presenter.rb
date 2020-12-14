class DitLandingPagePresenter
  def initialize(content_item)
    @content_item = content_item
  end

  def translation_links
    translations = available_translations.map do |item|
      active = true if item.base_path == content_item.base_path
      {
        locale: item.locale,
        base_path: item.base_path,
        text: I18n.t("shared.language_names.#{item.locale}"),
        active: active,
      }
    end

    translations.sort_by { |t| t[:locale] == I18n.default_locale.to_s ? "" : t[:locale] }
  end

private

  attr_reader :content_item

  def available_translations
    content_item.linked_items("available_translations")
  end
end
