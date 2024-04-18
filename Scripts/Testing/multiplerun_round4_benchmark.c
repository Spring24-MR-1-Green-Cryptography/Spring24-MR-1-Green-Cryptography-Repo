#include <stdio.h>
#include <stdlib.h>
#include <oqs/oqs.h>
#include <time.h>

#define NUM_RUNS 1000

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
    char filename[256];
    // Specify algorithm
    const char *kem_alg = OQS_KEM_alg_kyber_1024;
    snprintf(filename, sizeof(filename), "%s_benchmark_data.csv", kem_alg);

    FILE *fp = fopen(filename, "w+");
    if (!fp) {
        fprintf(stderr, "Could not open file %s\n", filename);
        return EXIT_FAILURE;
    }

    fprintf(fp, "%s\n", kem_alg);
    fprintf(fp, "Run,Keygen Time (ms),Encryption Time (ms),Decryption Time (ms)\n");

    for (int i = 0; i < NUM_RUNS; i++) {
        OQS_KEM *kem = NULL;
        uint8_t *public_key = NULL, *secret_key = NULL, *ciphertext = NULL;
        uint8_t *shared_secret_e = NULL, *shared_secret_d = NULL;
        double keygen_time, encrypt_time, decrypt_time;
        clock_t start, end;
        OQS_STATUS rc;

        OQS_init();

        kem = OQS_KEM_new(kem_alg);
        if (kem == NULL) {
            fprintf(stderr, "Failed to create KEM object for %s\n", kem_alg);
            return EXIT_FAILURE;
        }

        // Memory Allocation
        public_key = malloc(kem->length_public_key);
        secret_key = malloc(kem->length_secret_key);
        ciphertext = malloc(kem->length_ciphertext);
        shared_secret_e = malloc(kem->length_shared_secret);
        shared_secret_d = malloc(kem->length_shared_secret);
        if (!public_key || !secret_key || !ciphertext || !shared_secret_e || !shared_secret_d) {
            fprintf(stderr, "ERROR: malloc failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
            continue;
        }

        // Key gen
        start = clock();
        rc = OQS_KEM_keypair(kem, public_key, secret_key);
        end = clock();
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_keypair failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
            continue;
        }
        keygen_time = ((double) (end - start)) / CLOCKS_PER_SEC * 1000;

        // Encapsulation
        start = clock();
        rc = OQS_KEM_encaps(kem, ciphertext, shared_secret_e, public_key);
        end = clock();
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_encaps failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
            continue;
        }
        encrypt_time = ((double) (end - start)) / CLOCKS_PER_SEC * 1000;

        // Decapsulation
        start = clock();
        rc = OQS_KEM_decaps(kem, shared_secret_d, ciphertext, secret_key);
        end = clock();
        if (rc != OQS_SUCCESS) {
            fprintf(stderr, "ERROR: OQS_KEM_decaps failed!\n");
            cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
            continue;
        }
        decrypt_time = ((double) (end - start)) / CLOCKS_PER_SEC * 1000;

        fprintf(fp, "%d,%.3f,%.3f,%.3f\n", i + 1, keygen_time, encrypt_time, decrypt_time);

        cleanup(secret_key, shared_secret_e, shared_secret_d, public_key, ciphertext, kem);
    }

    fclose(fp);
    return EXIT_SUCCESS;
}
