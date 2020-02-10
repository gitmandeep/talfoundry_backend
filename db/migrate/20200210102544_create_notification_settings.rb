class CreateNotificationSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_settings do |t|
      t.references :user, foreign_key: true
      t.boolean :someone_sends_me_an_invitation, :default => true
      t.boolean :a_job_is_posted_or_modified, :default => true
      t.boolean :a_proposal_is_received, :default => true
      t.boolean :an_interview_is_accepted_or_offer_terms_are_modified, :default => true
      t.boolean :an_interview_or_offer_is_declined_or_withdrawan, :default => true
      t.boolean :an_offer_is_accepted, :default => true
      t.boolean :a_job_posting_will_expire_soon, :default => true
      t.boolean :a_job_posting_expired, :default => true
      t.boolean :an_interview_is_initiated, :default => true
      t.boolean :an_offer_or_interview_invitation_is_received, :default => true
      t.boolean :an_offer_or_interview_invitation_is_withdrawn, :default => true
      t.boolean :a_proposal_is_rejected, :default => true
      t.boolean :a_job_I_applied_to_has_been_cancelled_or_closed, :default => true
      t.boolean :a_hire_is_made_or_a_contract_begins, :default => true
      t.boolean :contract_terms_are_modified, :default => true
      t.boolean :a_contract_ends, :default => true
      t.boolean :payment_receipts_and_other_finacial_related_emails, :default => true
    	t.uuid	 	:uuid, default: "gen_random_uuid()", null: false


      t.timestamps
    end
  end
end
