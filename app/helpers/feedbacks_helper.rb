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
    ['Abuse', '2']
    ]
  end

  def active_status_value(active_status)
    @active_status_value = ""
    if active_status == 0
      @active_status_value = "Active"
    elsif active_status == 1
      @active_status_value = "Spam"
    elsif active_status == 2
      @active_status_value = "Abuse"
    end
    return @active_status_value
  end
end
