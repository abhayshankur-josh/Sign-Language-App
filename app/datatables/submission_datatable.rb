class SubmissionDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    # TODO : Failing on search query.
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id: { source: "Submission.id", cond: :eq },
      created_at: { source: "Submission.created_at", cond: :like },
      updated_at: { source: "Submission.updated_at", cond: :like },
      approver_id: { source: "Submission.approved_by_id", cond: :eq },
      approver_name: { source: "Approver.full_name", cond: :like },
      publisher_id: { source: "Submission.submitted_by_id", cond: :eq },
      publisher_name: { source: "Submitter.full_name", cond: :like },
      sign_id: { source: "Sign.id", cond: :eq },
      sign_title: { source: "Sign.title", cond: :like },
      video_id: { source: "Sign.video_id", cond: :eq },
      video_path: { source: "Video.video_path", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name

        id: record.id,
        created_at: record.created_at,
        updated_at: record.updated_at,
        approver_id: record.approver_id,
        approver_name: record.approver_name,
        publisher_id: record.publisher_id,
        publisher_name: record.publisher_name,
        sign_id: record.sign_id,
        sign_title: record.sign_title,
        video_id: record.video_id,
        video_path: record.video_path
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Submission.joins("LEFT JOIN users AS approvers ON approvers.id = submissions.approved_by_id")
                .joins("INNER JOIN signs ON signs.id = submissions.sign_id")
                .joins("INNER JOIN users AS submitters ON submitters.id = submissions.submitted_by_id")
                .joins("INNER JOIN videos ON videos.id = signs.video_id")
                .select('submissions.id, submissions.created_at, submissions.updated_at,
                          submissions.approved_by_id AS approver_id,
                          approvers.full_name AS approver_name,
                          submissions.submitted_by_id AS publisher_id,
                          submitters.full_name AS publisher_name,
                          signs.id AS sign_id,
                          signs.title AS sign_title,
                          signs.video_id AS video_id,
                          videos.video_path AS video_path')
  end
end
