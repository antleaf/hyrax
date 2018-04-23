module Hyrax
  class AdminSetPresenter < CollectionPresenter
    def total_items
      ActiveFedora::SolrService.count("{!field f=isPartOf_ssim}#{id}")
    end

    def total_viewable_items
      ActiveFedora::Base.where("isPartOf_ssim:#{id}").accessible_by(current_ability).count
    end

    # AdminSet cannot be deleted if default set or non-empty
    def disable_delete?
      AdminSet.default_set?(id) || total_items > 0
    end

    # Message to display if deletion is disabled
    def disabled_message
      return I18n.t('hyrax.admin.admin_sets.delete.error_default_set') if AdminSet.default_set?(id)
      return I18n.t('hyrax.admin.admin_sets.delete.error_not_empty') if total_items > 0
    end

    def collection_type
      @collection_type ||= Hyrax::CollectionType.find_or_create_admin_set_type
    end

    def show_path
      Hyrax::Engine.routes.url_helpers.admin_admin_set_path(id)
    end

    def available_parent_collections(*)
      []
    end

    # For the Managed Collections tab, determine the label to use for the level of access the user has for this admin set.
    # Checks from most permissive to most restrictive.
    # @return String the access label (e.g. Manage, Deposit, View)
    def managed_access
      return I18n.t('hyrax.dashboard.my.collection_list.managed_access.manage') if current_ability.can?(:edit, solr_document)
      return I18n.t('hyrax.dashboard.my.collection_list.managed_access.deposit') if current_ability.can?(:deposit, solr_document)
      return I18n.t('hyrax.dashboard.my.collection_list.managed_access.view') if current_ability.can?(:read, solr_document)
      ''
    end

    # Determine if the user can perform batch operations on this admin set.  Currently, the only
    # batch operation allowed is deleting, so this is equivalent to checking if the user can delete
    # the admin set determined by criteria...
    # * user must be able to edit the admin set to be able to delete it
    # * the admin set itself must be able to be deleted (i.e., there cannot be any works in the admin set)
    # @return Boolean true if the user can perform batch actions; otherwise, false
    def allow_batch?
      return false unless current_ability.can?(:edit, solr_document)
      !disable_delete?
    end
  end
end
