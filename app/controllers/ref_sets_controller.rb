class RefSetsController < ApplicationController
  # GET /ref_sets
  # GET /ref_sets.xml
  def index
    @ref_sets = RefSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ref_sets }
    end
  end

  # GET /ref_sets/1
  # GET /ref_sets/1.xml
  def show
    @ref_set = RefSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ref_set }
    end
  end

  # GET /ref_sets/new
  # GET /ref_sets/new.xml
  def new
    @ref_set = RefSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ref_set }
    end
  end

  # GET /ref_sets/1/edit
  def edit
    @ref_set = RefSet.find(params[:id])
  end

  # POST /ref_sets
  # POST /ref_sets.xml
  def create
    @ref_set = RefSet.new(params[:ref_set])

    respond_to do |format|
      if @ref_set.save
        format.html { redirect_to(@ref_set, :notice => 'Ref set was successfully created.') }
        format.xml  { render :xml => @ref_set, :status => :created, :location => @ref_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ref_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ref_sets/1
  # PUT /ref_sets/1.xml
  def update
    @ref_set = RefSet.find(params[:id])

    respond_to do |format|
      if @ref_set.update_attributes(params[:ref_set])
        format.html { redirect_to(@ref_set, :notice => 'Ref set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ref_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ref_sets/1
  # DELETE /ref_sets/1.xml
  def destroy
    @ref_set = RefSet.find(params[:id])
    @ref_set.destroy

    respond_to do |format|
      format.html { redirect_to(ref_sets_url) }
      format.xml  { head :ok }
    end
  end
end
