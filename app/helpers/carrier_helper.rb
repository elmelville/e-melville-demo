module CarrierHelper
  def carrier_name_for(name, config=nil)
    config ||= client_config
    name = config.carriers.detect { |key|
      name.to_s == key.to_s || ( AppConfig.carriers[key.to_s].legacy_name && (AppConfig.carriers[key.to_s].legacy_name == name.to_s ))
    }.to_s
  end

  def carrier_installer_class_for(name, config=nil)
    return nil if name.blank?
    "carriers/aus_post/installer".camelize.constantize
  end

  def carrier_service_class_for(name, config=nil)
    return nil if name.blank?
    "carriers/aus_post/service".camelize.constantize
  end

  def carrier_partial_for(name, config=nil)  
    "carriers/aus_post_form"
  end

  def carrier_preference_for(name)
    "carriers/#{carrier_name_for(name)}/#{name}_preference".camelize.constantize
  end
  
  def client_carrier_choices
    if defined? client_config
      client_config.carriers.map{|key| [AppConfig.carriers[key.to_s].description, key.to_s]}
    end
  end

end
