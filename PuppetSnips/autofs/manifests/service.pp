class autofs::service {
    service { autofs:
              enable    => true,
              ensure    => running,
              hasstatus => true,
              pattern   => "automount",
              require   => Package[autofs],
             }
}
