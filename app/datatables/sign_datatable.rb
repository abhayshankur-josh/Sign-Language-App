class SignDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    @view_columns ||= {
      id: { source: "Sign.id" },
      description: { source: "Sign.description" },
      status: { source: "Sign.status" },
      title: { source: "Sign.title" },
      created_at: { source: "Sign.created_at" },
      updated_at: { source: "Sign.updated_at" },
      video_id: { source: "Sign.video_id" }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        description: record.description,
        status: record.status,
        title: record.title,
        created_at: record.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        updated_at: record.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
        video_id: record.video_id
      }
    end
  end

  def get_raw_records
    Sign.all
  end
end
