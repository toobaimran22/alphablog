class ArticlePolicy < ApplicationPolicy

  def index?
    user.admin_role? || user.writer_role? || user.editor_role?
  end
  # Only writers can create articles
  def create?
    user.writer_role?
  end

  # Only writers can update their own articles
  def update?
    user.writer_role? && record.user_id == user.id
  end

  # Alias edit? to update?
  def edit?
    update?
  end

  # Editors can approve articles
  def approve?
    user.editor_role?
  end

  # Admins can publish articles
  def publish?
    user.admin_role?
  end

  # Writers can destroy their own articles
  def destroy?
    user.writer_role? && record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      if user.nil?
        # Guest: only published articles
        scope.where(published: true)
      elsif user.admin_role?
        # Admin: only approved, unpublished articles (for publishing dashboard)
        scope.where(approved: true, published: false)
      elsif user.editor_role?
        # Editor: only unapproved articles
        scope.where(approved: false)
      elsif user.writer_role?
        # Writer: only their own articles
        scope.where(user_id: user.id)
      else
        # Fallback: nothing
        scope.none
      end
    end
  end
end