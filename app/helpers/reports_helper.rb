module ReportsHelper
  def categories
    {
      'Animals' => [
          'Stray/wild/dead animals',
          'Nuisance animal complaint',
          'Vicious animal complaint',
          'Pet wellness check request',
          'Injured animal report',
          'Bee/wasp removal request',
          'Animal in trap complaint',
          'Coyote interaction complaint',
          'Rodent complaint'
        ],
      'Trash, Recycling and Pickup' => [
          'Missed trash pickup complaint',
          'Missed recycling pickup complaint',
          'Missed yard waste pickup complaint',
          'Overflowing public receptacle complaint'
        ],
      'Transportation and Streets' => [
          'Pothole complaint',
          'Road hazard complaint',
          'Sewer complaint',
          'Water on street complaint',
          'Street light out complaint',
          'Sidewalk complaint',
          'Traffic light out complaint',
          'Pedestrian signal complaint',
          'Sign repair request',
          'Abandoned vehicle complaint',
          'Abandoned bicycle complaint',
          'Parking violation complaint',
          'Bike lane obstruction complaint',
          'Bike rack damage complaint'
        ],
      'Environmental' => [
          'Illegal dumping complaint',
          'Sanitation code violation complaint',
          'Air pollution complaint',
          'Water pollution complaint',
          'Tree trimming, debris cleanup, or removal request'
        ],
      'Consumer/Residential' => [
          'Business complaint',
          'City official complaint',
          'Graffiti removal request',
          'Building code violation complaint',
          'Commercial fire safety inspection request',
          'Building permit violation complaint',
          'Excessive noise complaint',
          'Property maintenance complaint',
          'Inoperable vehicles/junk/trash on property complaint',
          'Residential wellness check request',
          'Disability accessibility/accommodation request'
        ],
        'General Complaint / Other' => [
            'General Complaint'
        ]
    }
  end

  def get_categories
    categories.keys
  end

  def get_subcategories_by_category(category)
    categories[category]
  end
end
