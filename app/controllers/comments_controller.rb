# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show; end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.votos = 0
    publication = Publication.find(comment_params['publication_id'])
    if not current_user.reputation
      current_user.reputation = 0
    end
    current_user.reputation += 1
    respond_to do |format| 
      if @comment.save && current_user.save
        format.html do
          redirect_to publication, notice: 'Comment was successfully created.'
        end
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html do
          redirect_to @comment, notice: 'Comment was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html do
        redirect_to comments_url, notice: 'Comment was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content, :user_id, :publication_id)
  end
end
