class My::MenusController < ApplicationController
  def show
    @filters = Current.user.filters.all
    @boards = Current.user.boards.ordered_by_recently_accessed
    @projects = Current.account.projects.order(:name)
    @tags = Current.account.tags.all.alphabetically
    @users = Current.account.users.active.alphabetically
    @accounts = Current.identity.accounts

    fresh_when etag: [ @filters, @boards, @projects, @tags, @users, @accounts ]
  end
end
