class SiteGuidesController < ApplicationController
  # GET /site_guides
  # GET /site_guides.xml
  def index
    @site_guides = SiteGuide.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_guides }
    end
  end

  # GET /site_guides/1
  # GET /site_guides/1.xml
  def show
    @site_guide = SiteGuide.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_guide }
    end
  end

  # GET /site_guides/new
  # GET /site_guides/new.xml
  def new
    @site_guide = SiteGuide.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_guide }
    end
  end

  # GET /site_guides/1/edit
  def edit
    @site_guide = SiteGuide.find(params[:id])
  end

  # POST /site_guides
  # POST /site_guides.xml
  def create
    @site_guide = SiteGuide.new(params[:site_guide])

    respond_to do |format|
      if @site_guide.save
        format.html { redirect_to(@site_guide, :notice => 'Site guide was successfully created.') }
        format.xml  { render :xml => @site_guide, :status => :created, :location => @site_guide }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_guide.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_guides/1
  # PUT /site_guides/1.xml
  def update
    @site_guide = SiteGuide.find(params[:id])

    respond_to do |format|
      if @site_guide.update_attributes(params[:site_guide])
        format.html { redirect_to(@site_guide, :notice => 'Site guide was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_guide.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_guides/1
  # DELETE /site_guides/1.xml
  def destroy
    @site_guide = SiteGuide.find(params[:id])
    @site_guide.destroy

    respond_to do |format|
      format.html { redirect_to(site_guides_url) }
      format.xml  { head :ok }
    end
  end
end
