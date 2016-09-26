class Audited < SimpleDelegator
  # delegate :id, :to => :__getobj__

  def save
    role_audits.build(audit_params)
    super
  end

private

  def audit_params
    { action: action, audited_changes: changes }
  end

  def action
    if new_record?
      'create'
    else
      'update'
    end
  end
end
