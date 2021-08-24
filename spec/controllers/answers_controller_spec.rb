require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { FactoryBot.create(:question, author: user) }
  let(:answer) { FactoryBot.create(:answer, question: question, author: user) }

  describe 'GET #edit' do
    before { login (user) }
    before { get :edit, params: { question_id: question, id: answer }, format: :js }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'POST #create' do
    before { login (user) }
    context 'with valid attributes' do
      it 'save a new answers in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'PATCH #update' do
    context 'Author' do
      before { login (user) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer), format: :js  }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js  }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js  }
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template(:update)
        end
      end
    end

    context 'Not author' do
      before { login(not_author) }
      it 'can not edit another answers' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js  }
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end

    context 'Unauthenticated user' do
      it 'can not edit answers' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' }, format: :js  }
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to the question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author' do
      before { login(not_author) }

      it 'try delete the question' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to the question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
