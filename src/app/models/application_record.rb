class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include S3Tools
  include ImageTools
  include TokenTools

  private

  NAME_ID_REGEX = /\A[a-zA-Z0-9_]+\z/
  BASE64_URLSAFE_REGEX = /\A[a-zA-Z0-9\-_]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def set_aid
    self.aid ||= SecureRandom.base36(14)
  end

  #object.update(column.to_sym => mca_array.to_json)
  def add_mca_data(object, column, add_mca_array, save = false)
    mca_array = JSON.parse(object[column.to_sym])
    add_mca_array.each do |obj|
      mca_array.push(obj)
    end
    object[column.to_sym] = mca_array.to_json
    if save
      object.save
    end
  end
  def remove_mca_data(object, column, remove_mca_array, save = false)
    mca_array = JSON.parse(object[column.to_sym])
    remove_mca_array.each do |obj|
      mca_array.delete(obj)
    end
    object[column.to_sym] = mca_array.to_json
    if save
      object.save
    end
  end
end
