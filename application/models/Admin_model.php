<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Admin_model extends CI_Model {
  public function sign_in($post) {
    $this->db->where([
      'username' => $post['username'],
      'password' => hash('sha256', $post['password'])
    ]);
    $query = $this->db->get('admins');

    return $query->result();
  }
}

