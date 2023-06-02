CLASS zss_cl_week3_mustache DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF tys_books,
        book_name TYPE string,
        author    TYPE string,
      END OF tys_books,

      tyt_books TYPE STANDARD TABLE OF tys_books WITH DEFAULT KEY,

      BEGIN OF tys_books_list,
        list_name TYPE string,
        items     TYPE tyt_books,
      END OF tys_books_list,

      tyt_books_list TYPE STANDARD TABLE OF tys_books_list WITH KEY list_name.

    INTERFACES if_oo_adt_classrun.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_book_list RETURNING VALUE(rt_book_list) TYPE tyt_books_list .
ENDCLASS.



CLASS zss_cl_week3_mustache IMPLEMENTATION.
  METHOD get_book_list.
    rt_book_list = VALUE #(  ( list_name = 'Classics'
                               items = VALUE #(
                                                  ( book_name = 'Pride & Prejudice'
                                                    author    = 'Jane Austen' )
                                                  ( book_name = 'The Great Gatsby'
                                                    author    = 'F. Scott Fitzgerald' )
                                                  ( book_name = 'The Catcher in the Rye'
                                                    author    = 'JD Salinger' )
                                                  ( book_name = 'To Kill a Mockingbird'
                                                    author    = 'Harper Lee' )
                                                  ( book_name = 'Alice’s Adventures in Wonderland'
                                                    author    = 'Charles Dickens' ) )
                               )
                              ( list_name = 'Sci-Fi'
                               items = VALUE #(
                                                  ( book_name = 'The Time Machine'
                                                    author    = 'H.G. Wells' )
                                                  ( book_name = 'Twenty Thousand Leagues Under the Sea'
                                                    author    = 'Jules Verne' )
                                                  ( book_name = 'Do Androids Dream of Electric Sheep?'
                                                    author    = 'Philip K Dick' )
                                                  ( book_name = 'Dune'
                                                    author    = 'Frank Herbert' )
                                                  ( book_name = 'Jurassic Park'
                                                    author    = 'Michael Crichton' ) )
                                 )
                                ).
  ENDMETHOD.

  METHOD if_http_service_extension~handle_request.
    DATA(lt_book_list) = get_book_list( ).
    response->set_content_type( 'text/html' ).

    TRY.
        DATA(lo_mustache) = zcl_mustache=>create(
            '<b>Genre: {{list_name}}<b>' &&
            '<table><tr><th style="width:70%">Book Name</th><th>Author</th>{{#items}}' &&
            '  <tr><td style="width:70%" >{{book_name}}</td>' &&
            '      <td>{{author}}</td></tr>' &&
            '{{/items}}</table></br>'
        ).

        DATA(lv_output) = |<h2>Week 2 Challenge : My Book List</h2></br>| && lo_mustache->render( lt_book_list ).
        response->set_text( lv_output ).
      CATCH zcx_mustache_error INTO DATA(lo_error).
        response->set_status( 500 ).
        response->set_text( lo_error->get_text(  ) ).
    ENDTRY.

  ENDMETHOD .

  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(lt_book_list) = get_book_list( ).
        DATA(cu_newline) = cl_abap_char_utilities=>newline.

        DATA(lo_mustache) = zcl_mustache=>create(
                         'Genre: {{list_name}}' && cu_newline && '{{>list_template}}' ).

        DATA(lo_partial) = zcl_mustache=>create(
                          '{{#items}}' && cu_newline &&
                         '-- {{book_name}} - {{author}}'  && cu_newline &&
                         '{{/items}}' && cu_newline
                          ).

        lo_mustache->add_partial( " Register the partial
                    iv_name = 'list_template'
                    io_obj = lo_partial ).

        out->write( lo_mustache->render( lt_book_list )  ).

      CATCH zcx_mustache_error.
        out->write( |something went wrong!!!| ).
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
