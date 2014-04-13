class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, only: [:edit, :destroy, :update, :index_draft]

  # GET /posts
  # GET /posts.json
  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order(post_date: :desc).page(params[:page])
    else
      @posts = Post.published.order(post_date: :desc).page(params[:page])
      @title = "Свежие посты"
    end
  end

  def index_travel
    if params[:tag]
      @posts = Post.where(post_type: "travel").tagged_with(params[:tag])
    else
      @posts = Post.where(post_type: "travel").order(post_date: :desc)
      @title = "Свежие посты"
    end
    render 'index_travel'
  end

  def map_finder
    @posts_with_geo = Post.where(post_type: 'travel')
    @hash = Gmaps4rails.build_markers(@posts_with_geo) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.json({:title => post.post_title})
      marker.infowindow ('<a target="_blank" href="' + post_path(post) + '">' + post.post_title + '</a>')
    end
    render 'map_finder'
  end

  #
  def index_draft
    if params[:tag]
      @posts = Post.where(post_status: "draft").tagged_with(params[:tag]).page(params[:page])
    else
      @posts = Post.where(post_status: "draft").order(post_date: :desc).page(params[:page])
      @title = "Свежие посты"
    end
    render 'index'
  end

  def index_by_date
    month_from = params[:month] || 1
    month_to = params[:month] || 12
    date_from = Date.strptime("1/#{month_from}/#{params[:year]}", '%d/%m/%Y')
    date_to = Date.strptime("1/#{month_to}/#{params[:year]}", '%d/%m/%Y')
    @posts = Post.where(post_date: date_from..date_to.end_of_month).order(post_date: :asc)
    # @posts = Post.order(post_date: :desc)
    render 'index_date'
  end

  def retina
    if session[:retina]
      session[:retina] = false
      @retina_state = "Normal"
    else
      session[:retina] = true
      @retina_state = "Retina"
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { @retina_state }
    end
  end


  # GET /posts/1
  # GET /posts/1.json
  def show
    @title = @post.post_title
    # Показываем похожие посты (имеющие совпадающие теги)
    # @related_posts = Post.tagged_with(@post.tag_list, any: true).order(created_at: :desc).limit(6)
    @related_posts_2 = @post.find_related_tags.limit(5)
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.post_title = I18n.t('draft_title')
    @post.post_status = 'draft'
    @post.post_content = "Тут будет текст"
    @post.post_type = "blog"
    @post.comment_status = 'closed'
    @tag_list = []
    @geolocation_list = []
    Post.tag_counts_on(:tags).sort { |a, b| a.name <=> b.name }.each do |tag|
      @tag_list << tag.to_s
    end
    gon.tag_list = @tag_list
    Post.tag_counts_on(:geolocations).sort { |a, b| a.name <=> b.name }.each do |tag|
      @geolocation_list << tag.to_s
    end
    gon.geolocation_list = @geolocation_list
    @tag_list
    @geolocation_list
  end

  # GET /posts/1/edit
  def edit
    @tag_list = []
    @geolocation_list = []
    Post.tag_counts_on(:tags).sort { |a, b| a.name <=> b.name }.each do |tag|
      @tag_list << tag.to_s
    end
    gon.tag_list = @tag_list
    Post.tag_counts_on(:geolocations).sort { |a, b| a.name <=> b.name }.each do |tag|
      @geolocation_list << tag.to_s
    end
    gon.geolocation_list = @geolocation_list
    @tag_list
    @geolocation_list
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, :flash => {:info => "Пост успешно изменен и сохранен в новом, в лучшем виде!"} }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to :back, :flash => {:info => "Пост благополучно удален!"} }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_post_name(params[:id]) || @post = Post.find(params[:id]) # TODO Может надо отключить в будущем поиск поста по его ID в базе?
    rescue
      render file: 'public/404', status: 404
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:geotag, :latitude, :longitude, :retina, :geolocation_list, :tag_list, :post_date, :post_title, :post_content, :post_status, :comment_status, :post_name, :post_type)
    end
end
