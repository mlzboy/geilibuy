module Admin::PaymentsHelper
    def show_payment_url(payment)
    unless payment.parent_id.blank?
      concat "#{payment.name}"
    else
      concat raw %Q{<a href="/admin/payments/#{payment.id}/sub">#{payment.name}</a>}
    end
  end
end
