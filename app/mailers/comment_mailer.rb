class CommentMailer < ActionMailer::Base
  
	default from: "codechallenge@orasi.com"

	def new_comment(user, comment)
		@user = user 
		@comment = comment
		mail(to: User.all_admin_email_addresses, subject: "Comment Posted for #{comment.month.capitalize} #{comment.league.capitalize}")
	end

	def reply_comment(user, reply_user,old_comment, new_comment)
		@user = user 
		@reply_user = reply_user
		@old_comment = old_comment
		@new_comment = new_comment
		mail(to: user, subject: "Reply To Comment For #{old_comment.month.capitalize} #{old_comment.league.capitalize}")
	end

	def updated_comment(user, old_comment, new_comment)
		@user = user 
		@old_comment = old_comment
		@new_comment = new_comment
		mail(to: User.all_admin_email_addresses, subject: "Comment Edited for #{old_comment.month.capitalize} #{old_comment.league.capitalize}")
	end

	def deleted_comment(user, comment, deleter)
		@user = user 
		@comment = comment
		@deleter = deleter
		mail(to: User.all_admin_email_addresses, subject: "Comment Deleted for #{comment.month.capitalize} #{comment.league.capitalize}")
	end
end
