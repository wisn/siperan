<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Admin extends CI_Controller {
  public function __construct() {
    parent::__construct();
  }

  public function index() {
    redirect('/admin/sign_in');
  }

  public function sign_in() {
    if (($user = $this->session->userdata('user')))
      if ($user['level'] == 'admin') redirect('/admin/dashboard');

    if ($this->input->method() == 'get') {
      $data = [
        'page' => 'admin/sign_in',
        'title' => 'Masuk sebagai Admin | SIPERAN'
      ];

      $this->load->view('admin/sign_in', $data);
    }
    else if ($this->input->method() == 'post') {
      $this->load->model('Admin_model', 'admin');

      $post = $this->input->post(NULL, TRUE);
      $admin = $this->admin->sign_in($post);
      if (!empty($admin)) {
        $this->session->set_userdata('user', [
          'level' => 'admin',
          'data' => ['username' => $admin['username']]
        ]);

        redirect('/admin/dashboard');
      }
      else {
        $msg = 'Username dan/atau password salah!';
        $this->session->set_flashdata('flashdata', $msg);

        redirect('/admin/sign_in');
      }
    }
  }

  public function dashboard() {
    if (empty($this->session->userdata('user')))
      redirect('/admin/sign_in');
    else if ($this->session->userdata('user')['level'] == 'staff')
      redirect('/staff/sign_in');

    $data = [
      'page' => 'admin/dashboard',
      'title' => 'Admin'
    ];

    $this->load->view('admin/dashboard', $data);
  }

  public function sign_out() {
    if ($this->input->method() == 'get') {
      $this->session->unset_userdata('user');

      redirect('/admin/sign_in');
    }
  }
}

