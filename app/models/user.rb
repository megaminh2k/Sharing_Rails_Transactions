class User < Primary
  has_many :receiver_transaction, foreign_key: :receiver_id, class_name: "Transfer"
  has_many :receivers, through: :receiver_transaction

  has_many :sender_appointments, foreign_key: :sender_id, class_name: "Transfer"
  has_many :senders, through: :sender_appointments

  has_many :posts

  validates :money, numericality: { greater_than: 0 }, :allow_blank => true
  validates :name, length: {minimum: 5}

  after_commit :log_user_activity
  after_rollback :log_transaction_status

  def log_transaction_status
    Rails.logger.info("Transaction was not able to perform action")
  end

  def log_user_activity
    Rails.logger.info("Transaction succeeded!")
  end

  def money_transfer sender, receiver, amount
    Transfer.transaction do
      Transfer.create!(sender: sender, receiver: receiver, amount: amount)
      sender.money = sender.money - amount
      receiver.money = receiver.money + amount
      sender.save!
      receiver.save!
    end
  end

  def self.new_user_post context, user
    user.money = context.to_i + user.money

    Primary.transaction do
      Primary2.transaction do
        user.save!
        p = Post.new(context: context, user_id: user.id)
        p.save!
      end
    end
  end

  def self.new_money money, user
    Primary.transaction do
      user.money = user.money/money
      user.save!
    end
  rescue
    puts "Can't devide money to zero"
  end

  def self.new_money money, user
    Primary.transaction do
      user.money = user.money/money
      user.save!
    end
  rescue
    puts "Can't devide money to zero"
  end

  def self.decrease_money user, money
    User.transaction do
      user.money = user.money - money
      user.save
      if money < 10
        puts "money < 10"
        raise Exception
      end
    end
  end

  def self.nested_transfer(sender, receiver, amount)
    User.transaction do
      tra = Transfer.first
      tra.sender = sender
      tra.receiver = receiver
      tra.amount = amount
      tra.save!
      User.decrease_money(sender, amount)
    end
  end
end
