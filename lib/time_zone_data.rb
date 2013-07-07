#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: time_zone_data.rb
#
#-----------------------------------------------------------------------------

module TimeZoneData

  def self.generate(time_zone)
    tz_period = ActiveSupport::TimeZone.new(time_zone).tzinfo.current_period

    if tz_period.start_transition.present?
      tz_std_period, tz_dst_period = tz_period.start_transition.offset.dst? ?
                                       [tz_period.end_transition, tz_period.start_transition] : [tz_period.start_transition, tz_period.end_transition]

      tz_dst_period.present? ? "#{offset_to_s(tz_std_period.offset)} #{offset_to_s(tz_dst_period.offset)}, #{period_to_s(tz_dst_period)}, #{period_to_s(tz_std_period)}" :
                               "#{offset_to_s(tz_std_period.offset)}"
    else
      "#{offset_to_s(tz_period.offset)}"
    end
  end

  protected
    def self.period_to_s(period)
      m = period.local_end.to_datetime.month
      w = period.local_end.to_datetime.cweek - period.local_start.to_datetime.beginning_of_month.cweek + 1
      d = period.local_end.to_datetime.wday
      h = period.local_end.to_datetime.strftime("%H:%M:%S")
      "M#{m}.#{w}.#{d}/#{h}"
    end

    def self.offset_to_s(offset_info)
      abbreviation = offset_info.abbreviation
      offset = offset_info.utc_total_offset
      offset_str = offset > 0 ? "-#{offset/3600}" : "+#{offset.abs/3600}"

      "#{abbreviation}#{offset_str}"
    end

end
