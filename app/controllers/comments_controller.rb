class CommentsController < ApplicationController
    layout false
    skip_before_action :verify_authenticity_token
    
    def index
        @comment = Post.find(params[:post_id]).comments.find_all
        pp @comment
        if @comments = Comment.where(post_id: params[:post_id])
            render json: {comments: @comments}, status: 200
        end
    end

    def create
        @json_data = JSON.parse(request.raw_post)
        pp '1!!!!'
        pp @json_data
        pp '1!!!!'
        pp params[:username]
        @c = Comment.new(@json_data)
        pp @c
        @post = Post.find(params[:post_id])
        @comment = @post.comments.create(@json_data)
        pp @comment
        @comment.user_id = User.find_by(name: params[:username]).id
        if @comment.save
            render json: @comment
        else
            render json: @comment.errors
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        if @comment.destroy()
            render json: {}, status: 200
        else
            render json: {}, status: 500
        end
    end

    def show
        @comment = Post.find(params[:post_id]).comments.find(params[:id])
    end

    private def comment_params
        params.require(:comment).permit(:username, :body, :mark)
        #params.permit(:username, :body, :mark)
    end
end
