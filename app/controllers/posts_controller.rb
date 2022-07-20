class PostsController < ApplicationController
    #http_basic_authenticate_with name:"admin", password: "123", except: [:index, :show]
    layout false
    skip_before_action :verify_authenticity_token
    def index
        @post = Post.all
        render json: {posts: @post}, status: 200
    end

    def new
        @post = Post.new
    end

    def destroy
        @post = Post.find(params[:id])
        @user = User.find(@post.user_id)
        @countOfPosts = @user.countOfPosts
        @countOfPosts -= 1
        if @post.destroy() && @user.update(countOfPosts: @countOfPosts)
          render json: {}, status: 200
        else
          render json: {}, status: 500
        end

    end

    def update
        @json_data = JSON.parse(request.raw_post)
        @post = Post.find(params[:id])
        if @post.update(@json_data)
            render json: @post
        else
            render json: @post.errors
        end
    end

    def edit
        @post = Post.find(params[:id])
      end

    def show
        @post = Post.find(params[:id])
    end

    def create
        @json_data = JSON.parse(request.raw_post)
        @post = Post.new(@json_data)
        @user = User.find(@post.user_id)
        @countOfPosts = @user.countOfPosts
        @countOfPosts += 1

        if @post.save && @user.update(countOfPosts: @countOfPosts)
            render json: @post
        else
            render body: @post.errors
        end
    end

    private def post_params
        params.require(:post).permit(:title, :body)
      end

end
