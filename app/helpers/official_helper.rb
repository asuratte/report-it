module OfficialHelper
  def search
    [
    ['Status', 'status'],
    ['Severity', 'severity'],
    ['Address', 'address'],
    ['City', 'city'],
    ['State', 'state'],
    ['Zip', 'zip'],
    ['Description', 'description']
    ]
  end

  def status
    [
    ['New', 'New'],
    ['In Progress', 'In Progress'],
    ['Flagged', 'Flagged'],
    ['Resolved', 'Resolved']
    ]
  end

  def severity
    [
    ['Not Set', 'Not Set'],
    ['Low', 'Low'],
    ['Moderate', 'Moderate'],
    ['Major', 'Major'],
    ['Critical', 'Critical']
    ]
  end
end
