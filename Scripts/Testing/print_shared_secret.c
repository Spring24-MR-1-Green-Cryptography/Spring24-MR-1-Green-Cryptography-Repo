#include <stdio.h>
#include <stdlib.h>
#include <oqs/oqs.h>
#include <time.h>

void print_bytes_as_hex(const uint8_t *bytes, size_t bytes_len) {
    for (size_t i = 0; i < bytes_len; i++) {
        printf("%02X", bytes[i]);
    }
    printf("\n");
}


void cleanup(uint8_t *secret_key, uint8_t *shared_secret_e,
             uint8_t *shared_secret_d, uint8_t *public_key,
             uint8_t *ciphertext, OQS_KEM *kem) {
    if (kem != NULL) {
        OQS_MEM_secure_free(secret_key, kem->length_secret_key);
        OQS_MEM_secure_free(shared_secret_e, kem->length_shared_secret);
        OQS_MEM_secure_free(shared_secret_d, kem->length_shared_secret);
    }
    OQS_MEM_insecure_free(public_key);
    OQS_MEM_insecure_free(ciphertext);
    OQS_KEM_free(kem);
}

int main() {
    // Specify algorithm
    const char *kem_alg = OQS_KEM_alg_kyber_1024;
    OQS_KEM *kem = NULL;
    uint8_t *public_key = NULL, *secret_key = NULL, *ciphertext = NULL;
    uint8_t *shared_secret_e = NULL, *shared_secret_d = NULL;
    OQS_STATUS rc;

        OQS_init();

        kem = OQS_KEM_new(kem_alg);
        if (kem == NULL) {
            fprintf(stderr, "Failed to create KEM object for %s\n", kem_alg);
            return EXIT_FAILURE;
        }

        public_key = malloc(kem->length_public_key);
        secret_key = malloc(kem->length_secret_key);
        ciphertext = malloc(kem->length_ciphertext);
        shared_secret_e = malloc(kem->length_shared_secret);
        shared_secret_d = malloc(kem->length_shared_secret);

        if (!public_key || !secret_key || !ciphertext || !shared_secret_e || !shared_secret_d) {
            fprintf(stderr, "ERROR: malloc failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
        }

        rc = OQS_KEM_keypair(kem, public_key, secret_key);
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_keypair failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
        }

        rc = OQS_KEM_encaps(kem, ciphertext, shared_secret_e, public_key);
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_encaps failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
        }

        printf("Shared secret encryption: ");
        print_bytes_as_hex(shared_secret_e, kem->length_shared_secret);

        rc = OQS_KEM_decaps(kem, shared_secret_d, ciphertext, secret_key);
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_decaps failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
        }

        printf("Shared secret decryption: ");

        print_bytes_as_hex(shared_secret_d, kem->length_shared_secret);

        cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);

    return EXIT_SUCCESS;
}