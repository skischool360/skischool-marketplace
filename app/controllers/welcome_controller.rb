
class WelcomeController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :confirm_admin_permissions, only: [:admin_users,:admin_edit, :admin_destroy]
    before_action :set_user, only: [:admin_edit, :admin_show_user, :admin_update_user, :admin_destroy]
    protect_from_forgery :except => [:sumo_success]

    include ApplicationHelper

  def new_hire_packet
    file = "public/Homewood-Hire-Packet-2016-2017.pdf"
    if File.exists?(file)
      send_file file, :type=>"application/pdf", :x_sendfile=>true
    else
      flash[:notice] = 'File not found'
      redirect_to :index
    end
  end

  def recommended_accomodations
    file = "public/Recommended-Accomodations-Homewood.pdf"
    if File.exists?(file)
      send_file file, :type=>"application/pdf", :x_sendfile=>true
    else
      flash[:notice] = 'File not found'
      redirect_to :index
    end
  end

  def avantlink
    render 'avantlink_confirmation.txt', :layout => false
  end

  def index
    # @lesson = Lesson.new
    # @lesson_time = @lesson.lesson_time
  end

  def index_backup_may2017
    if current_user
      #HEAP TESTING - send a random LTV value to users via server-side API call.
      Heap.add_user_properties("#{current_user.heap_uuid}", ltv: "#{current_user.heap_random_ltv}")
      flash[:notice] = 'Thanks for signing in!'
    end
  end

  def sumo_success
    email=params[:email]
    LessonMailer.notify_sumo_success(email).deliver
    flash[:notice] = 'Thank you for subscribing! You can expect to receive a weekly email from us with useful tips for planning your next ski vacation. If you have any immediate questions, feel free to send a chat message using the widget below, or email us at support@snowschoolers.com.'
      flash[:sumo_success] = 'TRUE'
    redirect_to :index
  end

  def jackson_hole
  end

  def beginners_guide_to_tahoe
  end

  def learn_to_ski_packages
  end

  def comparison_shopping_referral
    @product = Product.find(params[:id])
    @current_user = current_user ? current_user.email : "Unknown"
    @unique_id = request.remote_ip
    puts "!!!! PREPARE TO SEND GA EVENT"
    GoogleAnalyticsApi.new.event('tracked-referrals', "#{@product.product_type} - #{@product.name} - #{@product.location.name}")
    LessonMailer.notify_comparison_shopping_referral(@product,@current_user,@unique_id).deliver
    redirect_to @product.url
  end

  def homewood_pass_referral
    @current_user = current_user ? current_user.email : "Unknown"
    @unique_id = request.remote_ip
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-Homewood_season_pass")
    LessonMailer.notify_homewood_pass_referral(@current_user,@unique_id).deliver
    redirect_to "http://www.skihomewood.com/ski-tickets/season-passes"
  end

def liftopia_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-liftopia_generic")
    LessonMailer.notify_liftopia_referral.deliver
    redirect_to "http://www.avantlink.com/click.php?tt=cl&amp;mi=10065&amp;pw=209735&amp;url=https%3A%2F%2Fwww.liftopia.com%2Fhomewood"
  end

  def mountain_collective_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-mountain_collective")
    LessonMailer.notify_mountain_collective_referral.deliver
    redirect_to "https://mountaincollective.com/?uest?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def sportsbasement_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-sports_basement")
    LessonMailer.notify_sportsbasement_referral.deliver
    redirect_to "https://rentals.sportsbasement.com/rent/ski-rentals/adult-basic-ski-package?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def tahoedaves_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-tahoe_daves")
    LessonMailer.notify_tahoedaves_referral.deliver
    redirect_to "https://rentals.tahoedaves.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def skibutlers_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "custom-ski_butlers")
    LessonMailer.notify_skibutlers_referral.deliver
    redirect_to "https://www.skibutlers.com/portal/Snowschoolers%20Guest?utm_campaign=SnowSchoolers_beginner_guide"
  end 

  def homewood_learn_to_ski_referral
    GoogleAnalyticsApi.new.event('tracked-referrals', "BGT-homewood_learn_to_ski")
    LessonMailer.notify_homewood_learn_to_ski_referral.deliver
    redirect_to "http://www.skihomewood.com/learn-ski-or-ride-deal?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def homewood_referral
    resort = "Homewood"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-homewood")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.skihomewood.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def kirkwood_referral
    resort = "Kirkwood"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-kirkwood")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "https://www.kirkwood.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def alpine_referral
    resort = "Alpine Meadows"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-alpine")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://squawalpine.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def squaw_referral
    resort = "Squaw Valley"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-squaw")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://squawalpine.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def sugar_bowl_referral
    resort = "Sugar Bowl"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-sugar_bowl")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.sugarbowl.com/home?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def heavenly_referral
    resort = "Heavenly"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-heavenly")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "https://www.skiheavenly.com?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def northstar_referral
    resort = "Northstar"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-northstar")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "https://www.northstarcalifornia.com?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def mt_rose_referral
    resort = "Mt. Rose"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-mt_rose")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://skirose.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def sierra_referral
    resort = "Sierra at Tahoe"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-sierra")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "https://www.sierraattahoe.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def boreal_referral
    resort = "Boreal"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-boreal")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.rideboreal.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def diamond_peak_referral
    resort = "Diamond Peak"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-diamond_peak")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.diamondpeak.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def tahoe_donner_referral
    resort = "Tahoe Donner"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-tahoe_donner")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.tahoedonner.com/downhill-ski/rates/day-tickets/?utm_campaign=SnowSchoolers_beginner_guide"
  end

  def donner_ski_ranch_referral
    resort = "Donner Ski Ranch"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-donner_ski_ranch")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "https://www.donnerskiranch.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end 

  def soda_springs_referral
    resort = "Soda Springs"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-soda_springs")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://www.skisodasprings.com/?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def granlibakken_referral
    resort = "Granlibakken"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-granlibakken")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://granlibakken.com/ski-board-sled-hill/?utm_campaign=SnowSchoolers_beginner_guide"
  end  

  def sky_tavern_referral
    resort = "Sky Tavern"
    user = current_user ? current_user.email : "Unknown User"
    GoogleAnalyticsApi.new.event('tracked-referrals', "resort_guide-sky_tavern")
    LessonMailer.notify_resort_referral(resort,user).deliver
    redirect_to "http://skytavern.org/?utm_campaign=SnowSchoolers_beginner_guide"
  end      

  def about_us
  end

  def launch_announcement
  end

  def road_conditions
  end

  def accommodations
  end

  def resorts
  end

  def admin_users
    @users = User.all.sort {|a,b| a.id <=> b.id}
    @exported_users = User.all
    respond_to do |format|
          format.html
          format.csv { send_data @exported_users.to_csv, filename: "all_users-#{Date.today}.csv" }
          format.xls
    end
  end

  def admin_edit
  end

  def admin_update_user
    if @user.update(user_params)
        redirect_to admin_users_path, notice: 'User was successfully updated. If email was changed, it will need to be confirmed.'
    else
      Rails.logger.info(@user.errors.inspect)
      redirect_to admin_edit_user_path(@user), notice: "Unsuccessful. Error: #{@user.errors.full_messages}"
    end
  end

  def admin_show_user
    redirect_to admin_users_path
  end

   def admin_destroy
    @user.destroy
    redirect_to admin_users_path
   end


  def apply
    @instructor = Instructor.new
    GoogleAnalyticsApi.new.event('instructor-recruitment', 'load-application-page')
    # if current_user.nil?
    #     LessonMailer.track_apply_visits.deliver
    #   else
    #     LessonMailer.track_apply_visits(current_user.email).deliver
    # end
  end

  def notify_admin
    if request.xhr?
      first_name = params[:first_name]
      last_name = params[:last_name]
      email = params[:email]
      if current_user.nil?
        LessonMailer.application_begun(email, first_name, last_name).deliver
      else
        LessonMailer.application_begun(current_user.email).deliver
      end
      render json: {notice: "Email has been validated."}
    end
  end

  def march_madness
    render 'march-madness'
  end

  def team_offsites
    render 'team-offsites'
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :user_type, :location_id, :password, :password_confirmation, :current_password)
    end

end
