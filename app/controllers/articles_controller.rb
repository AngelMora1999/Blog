class ArticlesController < ApplicationController
	# Callback con los metodos de rails before_action :validate_user, except:[:show,:index]
	#Es mejor validar con devise por redirecciona despues de iniciar seccion a donde estaba el usuario
	before_action :authenticate_user!, except: [:show,:index]
	before_action :set_article, except: [:index,:new,:create]
	#GET /articles
	def index
		@articles = Article.all
	end
	#GET /articles/:id
	def show
		@article.update_visits_count
		@comment = Comment.new
	end
	#GET /articles/new
	def new
		@article = Article.new
		@categories = Category.all
	end

	def edit
		
	end

	#POST /articles
	def create
		@article = current_user.articles.new(article_params)  #Esta al final lo medificamos por temas de seguridad para no sufrir ataques de injeccion of SQL
		@article.categories = params[:categories]
		if @article.save
			redirect_to @article
		else
			render :new
		end
	end
	#
	def destroy
		
		@article.destroy
		redirect_to articles_path
	end
	#PUT /articles
	def update
		
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	private

	def article_params
		params.require(:article).permit(:title,:body,:cover,:categories)
	end

	def set_article
		@article = Article.find(params[:id])
	end

	#Callbacks con rails
	#def validate_user
	#	redirect_to new_user_session_path
	#end
end