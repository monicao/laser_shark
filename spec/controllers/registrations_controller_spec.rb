require 'spec_helper'

describe RegistrationsController do

  logged_in_student

  context "not registered" do
    before :each do
      allow(current_student).to receive(:completed_registration?).and_return(nil)
    end
    describe "GET #new" do
      it "assigns a registration form to @form" do
        get :new
        expect(assigns(:form)).to be_a(RegistrationForm)
      end
      it "renders :new" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      it "assigns the registration form to @form" do
        post :create, student: attributes_for(:student)
        expect(assigns(:form)).to be_a(RegistrationForm)
      end
      context "with valid attributes" do
        it "does save the attributes to student" do
          expect do
            post :create, student: attributes_for(:student, first_name: "new")
            current_student.reload
          end.to change(current_student, :first_name)
        end
        it "redirects to root url" do
          post :create, student: attributes_for(:student)
          expect(response).to redirect_to root_url
        end
      end
      context "with invalid attributes" do
        it "does not save the attributes to student" do
          expect do
            post :create, student: attributes_for(:student, first_name: nil)
            current_student.reload
          end.not_to change(current_student, :first_name)
        end
        it "re-renders :new" do
          post :create, student: attributes_for(:student, first_name: nil)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "#must_be_unregistered" do 
    describe "GET #new" do
      it "redirects to root_url if current student has completed registration" do
        allow(current_student).to receive(:completed_registration?).and_return(true)
        get :new
        expect(response).to redirect_to root_url
      end
      it "does not redirect if current student hasn't completed registration" do
        allow(current_student).to receive(:completed_registration?).and_return(false)
        get :new
        expect(response).not_to redirect_to root_url
      end
    end
  end

end
