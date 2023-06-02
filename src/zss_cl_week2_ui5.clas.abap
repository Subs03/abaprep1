CLASS zss_cl_week2_ui5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA user TYPE string.
    DATA date TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zss_cl_week2_ui5 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->popup_message_toast( |App executed on { date } by { user }| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack  ) ).

    ENDCASE.

    client->set_next( VALUE #( xml_main = z2ui5_cl_xml_view=>factory(
        )->shell(
        )->page(
                title          = 'abap2UI5 - First Example'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
                    target = '_blank'
            )->get_parent(
            )->simple_form( title = 'Form Title' editable = abap_true
                )->content( 'form'
                    )->title( 'Input'
                    )->label( 'User'
                    )->input( value = client->_bind( user )
                    )->label( 'Date'
                    )->date_picker( value = client->_bind( date )
                    )->button(
                        text  = 'post'
                        press = client->_event( 'BUTTON_POST' )
         )->get_root( )->xml_get( ) ) ).
  ENDMETHOD.


ENDCLASS.
