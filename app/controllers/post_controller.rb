class PostController < ApplicationController
  def index
  end
  
  def show
    @post = Post.find(:first, :conditions => { :slug => params[:slug] })
   
    if !@post
      render "index"
    end
  end
  
  def list
    render :partial => "list", :layout => false
  end
end
