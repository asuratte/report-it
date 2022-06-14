module OfficialHelper
  def status
    [
    ['Select', nil],
    ['New', 'New'],
    ['In Progress', 'In Progress'],
    ['Flagged', 'Flagged'],
    ['Resolved', 'Resolved']
    ]
  end

  def severity
    [
    ['Select', nil],
    ['Low', 'Low'],
    ['Moderate', 'Moderate'],
    ['Major', 'Major'],
    ['Critical', 'Critical']
    ]
  end
end
