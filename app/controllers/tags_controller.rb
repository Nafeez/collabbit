# Controller for operations on tags in the database.  
#
# Author::      Eli Fox-Epstein, efoxepstein@wesleyan.edu
# Author::      Dimitar Gochev, dimitar.gochev@trincoll.edu
# Copyright::   Humanitarian FOSS Project (http://www.hfoss.org), Copyright (C) 2009.
# License::     http://www.gnu.org/copyleft/lesser.html GNU Lesser General Public License (LGPL)

class TagsController < ApplicationController
  def index
    @instance = Instance.find(params[:instance_id])
    @tags = @instance.tags.paginate(:all, :page => params[:page], :per_page => 20).sort{|a,b|a.name<=>b.name}
    return with_rejection unless Tag.listable? and @instance.viewable?
  end

  def show
    @instance = Instance.find(params[:instance_id])
    @tag = @instance.tags.find(params[:id])
    return with_rejection unless @tag.viewable? and @instance.viewable?
  end
  
  def destroy
    @instance = Instance.find(params[:instance_id])
    @tag = @instance.tags.find(params[:id])
    return with_rejection unless @tag.destroyable? 
    @tag.destroy
    flash[:notice] = TAG_DESTROYED
    redirect_to instance_tags_path(@instance)
  end
end