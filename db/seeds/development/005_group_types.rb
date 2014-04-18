require "./db/seed_data"
data = [
  {
    id: 1,
    name: 'Open',
    description: "Anyone can see the group, who's in it*, and what members post",
    is_group_visible: 1,
    is_memberlist_visible: 1,
    is_content_visible: 1,
    is_approval_required: 0
  },
  {
    id: 2,
    name: 'Private',
    description: "Anyone can see the group. Only members see who's in it* and what members post",
    is_group_visible: 1,
    is_memberlist_visible: 0,
    is_content_visible: 0,
    is_approval_required: 1
  },
  {
    id: 3,
    name: 'Secret',
    description: "Only members see the group, who's in it*, and what members post",
    is_group_visible: 0,
    is_memberlist_visible: 0,
    is_content_visible: 0,
    is_approval_required: 1
  }
]

SeedData.new('GroupType').load(data)