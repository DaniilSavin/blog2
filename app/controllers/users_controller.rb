class UsersController < ApplicationController
    # before_create :create_remember_token
    layout false
    skip_before_action :verify_authenticity_token
    def index
        if params['regBef'] # do
            tmp = DateTime.parse(params['regBef'])
            @user = User.where("created_at <= ?", tmp)

        else
            if params['regAft'] # posle
                tmp = DateTime.parse(params['regAft'])
                @user = User.where("created_at > ?", tmp)
            else
                @user = User.all
            end
        end
        render json: {users: @user}, status: 200
    end

    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
        @posts = @user.posts
        @comments = @user.comments
        render json: {users: @user, articles: @posts, comments: @comments}, status: 200
      
    end
    
    def destroy
        @user = User.find(params[:id])
        "if @user.countOfPosts > 0
            @posts = Post.where(user_id: @user.id)
            @posts.destroy_all
        end"
        if @user.countOfPosts == 0 && @user.destroy
            render json: {}, status: 200
        else
            render json: {error: 'this user has posts.'}, status: 500
        end
    end

    def update
        @json_data = JSON.parse(request.raw_post)
        @user = User.find(params[:id])
        if @user.update(@json_data)
            render json: @user
        else
            render json: @user.errors
        end
    end


    def create
        @json_data = JSON.parse(request.raw_post)
        @user = User.new(@json_data)
        @user.countOfPosts = 0
        if @user.save
            render json: @user
        else
            render json: @user.errors
        end
    end
    
    private def user_params
        params.permit(:name)
    end
end
