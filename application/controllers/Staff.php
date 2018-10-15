<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Staff extends CI_Controller {
  public function __construct() {
    parent::__construct();
  }

  public function sign_in() {
    if ($this->input->method() == 'get') {
      $data = [
        'page' => 'staff/sign_in',
        'title' => 'Masuk sebagai Staff | SIPERAN'
      ];

      $this->load->view('staff/sign_in', $data);
    }
    else if ($this->input->method() == 'post') {
      $this->load->model('Staff_model', 'staff');

      $post = $this->input->post(NULL, TRUE);
      $staff = $this->staff->sign_in($post);
      if (!empty($staff)) {
        $this->session->set_userdata('user_level', 'staff');

        redirect('/index.php/staff/dashboard');
      }
    }
	}
}

