module FeedbacksHelper
  def category
    [
    ['Complaint', 'Complaint'],
    ['Compliment', 'Compliment'],
    ['Suggestion', 'Suggestion'],
    ['Technical Issue', 'Technical Issue']
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

  def active_status
    [
    ['Active', '0'],
    ['Spam', '1'],
    ['Abuse', '1']
    ]
  end
end
