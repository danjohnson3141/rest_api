require "./db/seed_data"

if !AppLabelDictionary.find_by_key("invited").nil? && !AppLabelDictionary.find_by_key("registered").nil? && !AppLabelDictionary.find_by_key("attended").nil?

  data = [
    {id: 1, key: "invited", app_label_dictionary_id: AppLabelDictionary.find_by_key("invited").id},
    {id: 2, key: "registered", app_label_dictionary_id: AppLabelDictionary.find_by_key("registered").id},
    {id: 3, key: "attended", app_label_dictionary_id: AppLabelDictionary.find_by_key("attended").id}
  ]

  SeedData.new('EventRegistrationStatus').load(data)
end