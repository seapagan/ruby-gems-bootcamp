json.extract! course, :id, :user_id, :classroom_id, :service_id, :created_at, :updated_at
json.url course_url(course, format: :json)
