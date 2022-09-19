class Post < Primary2
  belongs_to :user

  validates :context, length: {minimum: 5}
end
